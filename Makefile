# assignments
ASSIGNMENT ?= ""
IGNOREDIRS := "^(\.git|bin|node_modules|docs|.idea|build)$$"
ASSIGNMENTS = $(shell find ./exercises -maxdepth 1 -mindepth 1 -type d | cut -d'/' -f3 | sort | grep -Ev $(IGNOREDIRS))

# output and intermediate directories
TMPDIR ?= "/tmp"
INTDIR := $(shell mktemp -d "$(TMPDIR)/$(ASSIGNMENT).XXXXXXXXXX")
OUTDIR := $(shell mktemp -d "$(TMPDIR)/$(ASSIGNMENT).XXXXXXXXXX")

# language specific config (tweakable per language)
FILEEXT := "ts"
EXAMPLE := "example.$(FILEEXT)"
TSTFILE := "$(ASSIGNMENT).test.$(FILEEXT)"

all: test

node_modules: package.json
	@npm prune
	@npm install

test-assignment: node_modules
	@printf "\e[4mRunning tests for $(ASSIGNMENT) assignment\e[0m\n"
	@cp gulpfile.js exercises/$(ASSIGNMENT)
	@cp package.json exercises/$(ASSIGNMENT)
	@cp exercises/grains/lib/big-integer.$(FILEEXT) $(OUTDIR)
	@sed 's/xit/it/g; s/xdescribe/describe/g' exercises/$(ASSIGNMENT)/$(TSTFILE) > $(INTDIR)/$(TSTFILE)
	@cp exercises/$(ASSIGNMENT)/$(EXAMPLE) $(INTDIR)/$(ASSIGNMENT).$(FILEEXT)
	@gulp lint test --input $(INTDIR) --output $(OUTDIR)

test:
	@for assignment in $(ASSIGNMENTS); do ASSIGNMENT=$$assignment $(MAKE) -s test-assignment || exit 1; done
