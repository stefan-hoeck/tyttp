package=kb.ipkg
idris2=idris2
codegen=node

.PHONY: build dist clean repl

build:
	$(idris2) --build $(package) --codegen $(codegen)

dist: build
	npx rollup --config rollup.config.js

clean:
	rm -rf build

repl:
	rlwrap $(idris2) --repl $(package)

run: build
	node build/exec/kb
