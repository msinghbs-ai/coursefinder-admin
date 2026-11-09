set -e
cd "$(dirname "$0")"
python3 gen_api.py
pandoc StudySearch-Website-API-v2-Developer-Guide.md -o plain.docx
python3 polish.py plain.docx StudySearch-Website-API-v2-Developer-Guide.docx
python3 /root/.claude/skills/synced/*/docx/scripts/office/soffice.py --headless --convert-to pdf StudySearch-Website-API-v2-Developer-Guide.docx >/dev/null 2>&1
pdfinfo StudySearch-Website-API-v2-Developer-Guide.pdf | grep Pages
rm -f plain.docx
