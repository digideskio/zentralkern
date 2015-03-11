.PHONY: test

MODULE_DIR = ./node_modules
BIN_DIR = $(MODULE_DIR)/.bin
MOCHA_BIN = $(BIN_DIR)/mocha
TEST_UNIT_DIR = ./test/unit
MOCHA_REPORTER = spec

install:
	npm install

clean:
	rm -rf $(MODULE_DIR)

test: test-unit

test-unit: $(MOCHA_BIN)
	$(MOCHA_BIN) --growl --reporter $(MOCHA_REPORTER) --compilers coffee:coffee-script/register --colors $(TEST_UNIT_DIR)

test-watch:
	$(MOCHA_BIN) --growl --reporter $(MOCHA_REPORTER) --watch --compilers coffee:coffee-script/register --colors $(TEST_UNIT_DIR)
