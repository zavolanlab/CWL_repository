#!/usr/bin/env cwl-runner

cwlVersion: {{cookiecutter.cwl_version}}
class: CommandLineTool

label: {{cookiecutter.tool_label}}

doc: |
  {{cookiecutter.tool_doc}}


#hints:
#  SoftwareRequirement:
   ## List dependencies with short names
#    packages:
#      Software name here:
#        specs: ["Provide SciCrunch identifier for required software"]
#        version: ["Include a list of versions that are known to work with this description"]
#  ResourceRequirement:
#    coresMin: 4

requirements:
  DockerRequirement:
    dockerPull: {{cookiecutter.dockerPull}}
# InlineJavascriptRequirement: {}


inputs:
  input1:
    type: File
#   format: [edam:format_XXXX]
    inputBinding:
      position: {{cookiecutter.input_position}}
#     prefix: -i
    doc: |
      {{cookiecutter.input_doc}}

  outfile_name:
    type: string
    doc: |
      Name of the outputfile. Given as String.


outputs:
  output1:
    type: stdout
#   format: [edam:format_XXXX]

stdout: $(inputs.outfile_name)


baseCommand: {{cookiecutter.base_command}}



# Namespaces and Schema
$namespaces:
  edam: http://edamontology.org/
  s: http://schema.org/

$schemas:
 - http://edamontology.org/EDAM_1.18.owl
 - https://schema.org/version/latest/schema.rdf


# METADATA
# Cite the underlying tool
s:mainEntity:
  - class: s:SoftwareSourceCode
  s:name: "{{cookiecutter.orig_software}}"
  s:about: >
    {{cookiecutter.orig_software_description}}

  s:url: {{cookiecutter.orig_software_url}}
  s:license: {{cookiecutter.orig_software_license}}

  s:creator:
  - class: s:Person
    s:name: "{{cookiecutter.orig_software_author}}"

  #s:publication:
  #- class: s:ScholarlyArticle
  #  id: http://dx.doi.org/?????
  #  s:name: "?????"
  #  s:url: http://journal.?????

# Cite CWL
s:isPartOf:
  - class: s:CreativeWork
  s:name: Common Workflow Language
  s:url: http://commonwl.org/

# Identify yourself
s:author:
  - class: s:Person
  s:name: {{cookiecutter.author}}
  s:email: {{cookiecutter.email}}
  ## If you have one, use unambiguous identifiers like ORCID
  #  s:sameAs:
  #  - id: http://orcid.org/????-????-????-????
  s:worksFor:
  - class: s:Organization
    s:name: {{cookiecutter.organization}}
    s:location: {{cookiecutter.location}}
    s:department:
    - class: s:Organization
      s:name: {{cookiecutter.lab}}

#s:citation: xxxxx
s:codeRepository: {{cookiecutter.repo}}
s:dateCreated: {{cookiecutter.date}}

# Include a license
s:license: {{cookiecutter.license}}
s:copyrightHolder: {{cookiecutter.copyright_holder}}
