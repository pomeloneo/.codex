#!/usr/bin/env python3
"""
Convert documents to Markdown with AI-enhanced image descriptions.

This script demonstrates how to use MarkItDown with an OpenAI-compatible API
to generate detailed descriptions of images in documents (PowerPoint, PDFs
with images, etc.).

When a batch conversion is being run by Codex, prefer Codex's built-in image
understanding and parallel subagents where available. Use this script when the
conversion must run outside a Codex-managed task, such as CI or a plain
scheduled job.
"""

import argparse
import os
import sys
from pathlib import Path
from typing import Optional
from markitdown import MarkItDown
from openai import OpenAI


# Predefined prompts for different use cases
PROMPTS = {
    'scientific': """
Analyze this scientific image or diagram. Provide:
1. Type of visualization (graph, chart, microscopy, diagram, etc.)
2. Key data points, trends, or patterns
3. Axes labels, legends, and scales
4. Notable features or findings
5. Scientific context and significance
Be precise, technical, and detailed.
    """.strip(),
    
    'presentation': """
Describe this presentation slide image. Include:
1. Main visual elements and their arrangement
2. Key points or messages conveyed
3. Data or information presented
4. Visual hierarchy and emphasis
Keep the description clear and informative.
    """.strip(),
    
    'general': """
Describe this image in detail. Include:
1. Main subjects and objects
2. Visual composition and layout
3. Text content (if any)
4. Notable details
5. Overall context and purpose
Be comprehensive and accurate.
    """.strip(),
    
    'data_viz': """
Analyze this data visualization. Provide:
1. Type of chart/graph (bar, line, scatter, pie, etc.)
2. Variables and axes
3. Data ranges and scales
4. Key patterns, trends, or outliers
5. Statistical insights
Focus on quantitative accuracy.
    """.strip(),
    
    'medical': """
Describe this medical image. Include:
1. Type of medical imaging (X-ray, MRI, CT, microscopy, etc.)
2. Anatomical structures visible
3. Notable findings or abnormalities
4. Image quality and contrast
5. Clinical relevance
Be professional and precise.
    """.strip()
}


def convert_with_ai(
    input_file: Path,
    output_file: Path,
    api_key: str,
    model: Optional[str] = None,
    base_url: Optional[str] = None,
    prompt_type: str = "general",
    custom_prompt: Optional[str] = None
) -> bool:
    """
    Convert a file to Markdown with AI image descriptions.
    
    Args:
        input_file: Path to input file
        output_file: Path to output Markdown file
        api_key: API key for OpenAI or another OpenAI-compatible provider
        model: Model name. If omitted, uses OPENAI_MODEL, OPENROUTER_MODEL, or a small vision-capable default.
        base_url: Optional OpenAI-compatible base URL (for OpenRouter or other gateways)
        prompt_type: Type of prompt to use
        custom_prompt: Custom prompt (overrides prompt_type)
        
    Returns:
        True if successful, False otherwise
    """
    try:
        base_url = base_url or os.environ.get("OPENAI_BASE_URL")
        if not base_url and os.environ.get("OPENROUTER_API_KEY") and not os.environ.get("OPENAI_API_KEY"):
            base_url = "https://openrouter.ai/api/v1"

        default_model = "openai/gpt-4o-mini" if base_url and "openrouter.ai" in base_url else "gpt-4o-mini"
        model = model or os.environ.get("OPENAI_MODEL") or os.environ.get("OPENROUTER_MODEL") or default_model

        # Initialize OpenAI-compatible client.
        client_kwargs = {"api_key": api_key}
        if base_url:
            client_kwargs["base_url"] = base_url
        client = OpenAI(**client_kwargs)
        
        # Select prompt
        if custom_prompt:
            prompt = custom_prompt
        else:
            prompt = PROMPTS.get(prompt_type, PROMPTS['general'])
        
        print(f"Using model: {model}")
        print(f"Prompt type: {prompt_type if not custom_prompt else 'custom'}")
        print(f"Converting: {input_file}")
        
        # Create MarkItDown with AI support
        md = MarkItDown(
            llm_client=client,
            llm_model=model,
            llm_prompt=prompt
        )
        
        # Convert file
        result = md.convert(str(input_file))
        
        # Create output with metadata
        content = f"# {result.title or input_file.stem}\n\n"
        content += f"**Source**: {input_file.name}\n"
        content += f"**Format**: {input_file.suffix}\n"
        content += f"**AI Model**: {model}\n"
        content += f"**Prompt Type**: {prompt_type if not custom_prompt else 'custom'}\n\n"
        content += "---\n\n"
        content += result.text_content
        
        # Write output
        output_file.parent.mkdir(parents=True, exist_ok=True)
        output_file.write_text(content, encoding='utf-8')
        
        print(f"✓ Successfully converted to: {output_file}")
        return True
        
    except Exception as e:
        print(f"✗ Error: {str(e)}", file=sys.stderr)
        return False


def main():
    parser = argparse.ArgumentParser(
        description="Convert documents to Markdown with AI-enhanced image descriptions",
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog=f"""
Available prompt types:
  scientific    - For scientific diagrams, graphs, and charts
  presentation  - For presentation slides
  general       - General-purpose image description
  data_viz      - For data visualizations and charts
  medical       - For medical imaging

Examples:
  # Convert a scientific paper
  python convert_with_ai.py paper.pdf output.md --prompt-type scientific
  
  # Convert a presentation with OpenAI directly
  python convert_with_ai.py slides.pptx slides.md --model gpt-4o-mini --prompt-type presentation
  
  # Use OpenRouter or another OpenAI-compatible gateway
  python convert_with_ai.py diagram.png diagram.md --base-url https://openrouter.ai/api/v1 --model openai/gpt-4o-mini --custom-prompt "Describe this technical diagram"
  
  # Set API key via environment variable
  export OPENAI_API_KEY="sk-..."
  python convert_with_ai.py image.jpg image.md

Environment Variables:
  OPENAI_API_KEY        OpenAI API key (preferred if not passed via --api-key)
  OPENAI_BASE_URL       Optional OpenAI-compatible base URL
  OPENAI_MODEL          Optional default model name for AI image descriptions
  OPENROUTER_API_KEY    Optional OpenRouter key for OpenRouter-based routing
  OPENROUTER_MODEL      Optional OpenRouter model name

Popular Models (use with --model):
  gpt-4o-mini                   - Small OpenAI vision-capable example
  google/gemini-3-pro-preview   - Gemini Pro Vision example
        """
    )
    
    parser.add_argument('input', type=Path, help='Input file')
    parser.add_argument('output', type=Path, help='Output Markdown file')
    parser.add_argument(
        '--api-key', '-k',
        help='API key (or set OPENAI_API_KEY / OPENROUTER_API_KEY env var)'
    )
    parser.add_argument(
        '--base-url',
        default=None,
        help='Optional OpenAI-compatible base URL, such as https://openrouter.ai/api/v1'
    )
    parser.add_argument(
        '--model', '-m',
        default=None,
        help='Model to use (default: OPENAI_MODEL / OPENROUTER_MODEL / provider-specific small vision model)'
    )
    parser.add_argument(
        '--prompt-type', '-t',
        choices=list(PROMPTS.keys()),
        default='general',
        help='Type of prompt to use (default: general)'
    )
    parser.add_argument(
        '--custom-prompt', '-p',
        help='Custom prompt (overrides --prompt-type)'
    )
    parser.add_argument(
        '--list-prompts', '-l',
        action='store_true',
        help='List available prompt types and exit'
    )
    
    args = parser.parse_args()
    
    # List prompts and exit
    if args.list_prompts:
        print("Available prompt types:\n")
        for name, prompt in PROMPTS.items():
            print(f"[{name}]")
            print(prompt)
            print("\n" + "="*60 + "\n")
        sys.exit(0)
    
    # Get API key
    api_key = args.api_key or os.environ.get('OPENAI_API_KEY') or os.environ.get('OPENROUTER_API_KEY')
    if not api_key:
        print("Error: API key required. Set OPENAI_API_KEY or OPENROUTER_API_KEY, or use --api-key")
        sys.exit(1)
    
    # Validate input file
    if not args.input.exists():
        print(f"Error: Input file '{args.input}' does not exist")
        sys.exit(1)
    
    # Convert file
    success = convert_with_ai(
        input_file=args.input,
        output_file=args.output,
        api_key=api_key,
        model=args.model,
        base_url=args.base_url,
        prompt_type=args.prompt_type,
        custom_prompt=args.custom_prompt
    )
    
    sys.exit(0 if success else 1)


if __name__ == '__main__':
    main()
