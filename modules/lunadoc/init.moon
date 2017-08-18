
Project = require 'lunadoc.project'

->
  project, reason = Project.fromConfiguration!

  unless project
    return nil, reason

  project\loadTemplate!

  for document in project\getDocuments!
    outputFilePath = document.outputFilePath

    print 'writing file %s'\format outputFilePath

    document\createDirectories!

    s, r = project\render document
    unless s
      return nil, r

  s, r = project\copyFiles!
  unless s
    return nil, r

  return true
