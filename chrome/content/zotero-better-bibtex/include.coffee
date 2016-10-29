if not Zotero.BetterBibTeX
  Zotero.Promise.coroutine(->
    loader = Components.classes['@mozilla.org/moz/jssubscript-loader;1'].getService(Components.interfaces.mozIJSSubScriptLoader)

    for script in ["zotero-better-bibtex.js","lib/lokijs.js","lib/translit.js","lib/citeproc.js","lib/vardump.js","lib/fold-to-ascii.js","lib/punycode.js","dateparser.js","preferences.js","translators.js","translator-metadata.js","db.js","csl-localedata.js","pattern-formatter.js","Zotero.BetterBibTeX.PatternParser.js","keymanager.js","journalAbbrev.js","web-endpoints.js","schomd.js","cayw.js","debug-bridge.js","cache.js","autoexport.js","serialized.js"]
      try
        Zotero.debug('BBT: ' + script)
        loader.loadSubScript("chrome://zotero-better-bibtex/content/#{script}")
      catch err
        if Zotero.BetterBibTeX
          Zotero.BetterBibTeX.disabled = "#{script} load failed: #{err}"
          Zotero.BetterBibTeX.debug("BBT: #{script} load failed:", err)
        else
          Zotero.debug("BBT: #{script} load failed: #{err}")
        loader = null
        break

    if loader
      Zotero.debug('BBT: all loaded')
      try
        yield Zotero.Schema.schemaUpdatePromise
        Zotero.BetterBibTeX.init()
      catch err
        Zotero.BetterBibTeX.disabled = "Initialize failed: #{err}"
        Zotero.debug('BBT: failed to initialize: ' + err)
  )()
