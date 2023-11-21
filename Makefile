SERVICES_DIR = services
TIMERS_DIR = timers
SYSTEMD_DIR = /etc/systemd/system
SCRIPT_DIR = /usr/bin

SERVIES = $(wildcard $(SERVICES_DIR)/*)
TIMERS = $(wildcard $(TIMERS_DIR)/*)

SCRIPTS = \
	telegram-systemd \
	telegram.sh/telegram

INSTANCE ?= $(shell hostname)

INSTALL = install

all: install-systemd install-scripts

install-systemd:
	@mkdir -p $(SYSTEMD_DIR)
	@echo "Installing services to $(SYSTEMD_DIR)"
	@cp $(SERVICES) $(SYSTEMD_DIR)
	@echo "Installing timers to $(SYSTEMD_DIR)"
	@cp $(TIMERS) $(SYSTEMD_DIR)
	@echo "Executing 'systemctl daemon-reload'"
	@systemctl daemon-reload

install-scripts: $(SCRIPTS)
	for script in $(SCRIPTS); do \
		$(INSTALL) -m 750 $$script $(SCRIPT_DIR); \
	done

enable-timers:
	@for path in $(TIMERS); do \
		filename="$$(basename $$path)"; \
		timer=$$(echo "$$filename" | sed 's/@.timer/@$(INSTANCE).timer/'); \
		echo "Enabling timer $$timer"; \
		systemctl enable --now "$$timer"; \
	done

.PHONY: all install-systemd install-scripts enable-timers
