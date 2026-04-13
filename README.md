# Far West Legacy

Open-source, AI-assisted tool that extracts genealogical data from obituaries and contributes person records, relationships, memories, and source citations to the [FamilySearch Family Tree](https://www.familysearch.org).

## What It Does

Far West Legacy accepts an obituary — from a website URL, pasted text, or a photograph of a physical clipping — and:

1. **Extracts** structured genealogical data using the Anthropic Claude API
2. **Presents** the extracted data for user review and correction
3. **Contributes** to the FamilySearch Family Tree:
   - Person record with full vital data (name, gender, birth, death, burial)
   - Family relationships (spouse, parents, children, siblings)
   - Story Memory (obituary text preserved as a permanent memorial)
   - Photo Memory (obituary photograph, if available)
   - Source citation linking back to the original obituary
4. **Surfaces** FamilySearch record hints, directing the user to FamilySearch.org to review census and historical record matches

Every record is reviewed and confirmed by the user before any write to the Family Tree. Duplicate checking is performed before every write operation.

## Status

🚧 **In development** — not yet ready for use.

Currently building against the FamilySearch Integration (sandbox) environment. Production access requires completion of the FamilySearch Compatibility Review process.

## Stack

- **Python 3.12+**
- **Anthropic Claude API** — obituary text extraction (Haiku) and photo/vision processing (Sonnet)
- **Flask** — review UI
- **FamilySearch API** — tree writes, memories, sources, record hinting

## Cost Model

Far West Legacy is free to use. It uses a **Bring-Your-Own-Key** model — users supply their own [Anthropic API key](https://console.anthropic.com/) for AI processing. There is no commercial component, subscription fee, or monetization of any kind.

## Getting Started

> Setup instructions will be added when the project reaches a usable state.

## Contributing

Contributions are welcome. Please open an issue to discuss before submitting a pull request.

## License

[MIT](LICENSE)

---

*Far West Legacy is developed by [Cannon Digital LLC](https://farwestlegacy.com).*

