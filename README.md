![AX Semantics](https://github.com/axsemantics/api-docs/blob/master/source/images/logo.png) Semantics API Docs
========

Die Anwendung [my-ax](https://my.ax-semantics.com) ist das Self-Service-Portal der AX NLG Cloud. Alle Funktionen des Portals können auch über [die API](https://api.ax-semantics.com) verwendet werden, deren [Dokumentation](http://apidocs.ax-semantics.com) hier gepflegt wird.

Development
------------------------------

### Voraussetzungen
 - **Linux oder OS X** — Windows ist nicht getestet
 - **Ruby, Version 1.9.3 oder neuer**
 - **Bundler** — Falls der Befehl `bundle` nach der Ruby-Installation nicht vorhanden ist, muss `bundler` separat mit dem Befehl `gem install bundler` installiert werden.

### Setup ohne Docker

```shell
git clone https://github.com/axsemantics/api-docs.git
cd api-docs
bundle install
bundle exec middleman server
```
### Setup mit Docker

Alternativ kann Docker verwendet werden.

```shell
git clone https://github.com/axsemantics/api-docs.git
cd api-docs
docker build -t api-docs .
docker run -d -p 4567:4567 --name api-docs -v $(pwd):/app api-docs
```
Danach liegt die Dokumentation unter <http://localhost:4567>.

Mit dem Befehl

```shell
docker exec -ti api-docs rake build
```
wird eine deploy-fertige Version des Projekts im `build`-Verzeichnis erstellt.

Weitere Informationen über den [verwendeten Markdown-Stil](https://github.com/tripit/slate/wiki/Markdown-Syntax) und das [Deployment](https://github.com/tripit/slate/wiki/Deploying-Slate) befinden sich in der Slate-Dokumentation.

Fehler und Unklarheiten
-----------------------

Falls Unstimmigkeiten oder Fehler auffallen, können diese am besten über [einen Issue](https://github.com/axsemantics/api-docs/issues) geklärt werden.

Verwendete Tools
--------------------
- [Slate](https://github.com/tripit/slate)
- [GitHub Pages](https://pages.github.com)
- [Docker](https://docker.com)
