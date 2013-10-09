
CREDDIT_CFLAGS:=$(PROJCFLAGS)
CREDDIT_LDFLAGS:=$(PROJLDFILES) -L$(BUILD_DIR) -lreddit
ifdef F_MACOSX
	CREDDIT_LDFLAGS+=-lncurses
else
	CREDDIT_LDFLAGS+=-lncursesw
endif

ifdef STATIC
    CREDDIT_LDFLAGS+=`curl-config --cflags` `curl-config --libs`
endif

EXECUTABLE_NAME:=creddit
CREDDIT_DIR_CMP:=$(BUILD_DIR)/src
CREDDIT_DIR:=src

EXECUTABLE_FULL:=$(BUILD_DIR)/$(EXECUTABLE_NAME)

COMPILE_TARGETS+=$(EXECUTABLE_FULL)
CLEAN_TARGETS+=creddit_clean
INSTALL_TARGETS+=creddit_install

CREDDIT_SOURCES:=$(patsubst $(CREDDIT_DIR)/%,%,$(wildcard $(CREDDIT_DIR)/*.c))
CREDDIT_OBJECTS:=$(patsubst %,$(CREDDIT_DIR_CMP)/%,$(CREDDIT_SOURCES:.c=.o))

$(CREDDIT_DIR_CMP): | $(BUILD_DIR)
	$(ECHO) " MKDIR $(CREDDIT_DIR_CMP)"
	$(MKDIR) $(CREDDIT_DIR_CMP)

creddit: $(EXECUTABLE_FULL)

$(EXECUTABLE_FULL): libreddit $(CREDDIT_OBJECTS) | $(CREDDIT_DIR_CMP)
	$(ECHO) " CC $(EXECUTABLE_FULL)"
	$(CC) $(CREDDIT_OBJECTS) $(CREDDIT_CFLAGS) $(CREDDIT_LDFLAGS) -o $(EXECUTABLE_FULL)

creddit_clean:
	$(ECHO) " RM $(CREDDIT_DIR_CMP)"
	$(RM) -fr $(CREDDIT_DIR_CMP)

creddit_install: $(EXECUTABLE_FULL)
	$(ECHO) " INSTALL $(EXECUTABLE_FULL)"
	$(INSTALL) -m 0755 $(EXECUTABLE_FULL) $(PREFIX)/bin/

$(CREDDIT_DIR_CMP)/%.o: $(CREDDIT_DIR)/%.c | $(CREDDIT_DIR_CMP)
	$(ECHO) " CC $@"
	$(CC) $(CREDDIT_CFLAGS) -c $< -o $@
