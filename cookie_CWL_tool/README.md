# cookie_CWL_tool
cookiecutter template for CWL CommandLineTool

Simple template creating a folder containing the tool.cwl and tool-job.yml files.
You will be prompted for stuff like:
- cwlVersion
- docker image
- initial file names and formats
- Metadata (authors, organisations, licences)
- etc.

# How to
1. [Install cookiecutter](https://cookiecutter.readthedocs.io/en/latest/installation.html)
2. cd to destination folder
3. `cookiecutter https://github.com/ninsch3000/cookie_CWL_tool`

If you want to change the default values, clone the repo and edit cookiecutter.json. You can then also call cookiecutter on your local copy of cookie_CWL_tool.
