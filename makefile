# =======================================
#  Databricks Course - Makefile
# =======================================

VENV        ?= .venv
VENV_PY     = $(VENV)/bin/python
PY          = $(VENV_PY)
PIP         = $(VENV_PY) -m pip
SHELL       := /bin/bash

# Descubre el intérprete "bootstrap" para crear el venv:
#   1) python (shims de pyenv)
#   2) si no existe, python3
PY_BOOTSTRAP := $(shell command -v python || command -v python3)

# Identidad del kernel
KERNEL_NAME    ?= databricks-course
KERNEL_DISPLAY ?= Python ($(KERNEL_NAME))

.PHONY: help
help: ## Muestra esta ayuda
	@echo "Comandos disponibles:"
	@grep -E '^[a-zA-Z0-9_.-]+:.*?## ' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS=":.*?## "}; {printf "  \033[36m%-18s\033[0m %s\n", $$1, $$2}'

.PHONY: ensure-py
ensure-py: ## Verifica que el Python activo sea 3.10.x (pyenv local 3.10.14)
	@$(PY_BOOTSTRAP) -c 'import sys; assert sys.version_info[:2]==(3,10), f"Se requiere Python 3.10.x; detectado {sys.version.split()[0]}"; print(f"OK: usando Python {sys.version.split()[0]} ->", sys.executable)'

.PHONY: venv
venv: ensure-py ## Crea el entorno virtual (.venv) si no existe
	@test -d "$(VENV)" || "$(PY_BOOTSTRAP)" -m venv "$(VENV)"
	@echo "Entorno virtual: $(VENV)"

.PHONY: install
install: venv ## Instala/actualiza dependencias en el venv
	$(PIP) install --upgrade pip setuptools wheel
	@test -f requirements.txt || (echo "No existe requirements.txt"; exit 1)
	$(PIP) install -r requirements.txt
	@$(PY) -c "import sys; print('Usando:', sys.executable)"

.PHONY: kernel
kernel: ## Registra (o actualiza) el kernel de Jupyter para este venv
	@$(PY) -c "import ipykernel" || (echo "Falta 'ipykernel' en el entorno. Ejecuta 'make install' y verifica requirements.txt."; exit 1)
	@$(PY) -m ipykernel install --user --name "$(KERNEL_NAME)" --display-name "$(KERNEL_DISPLAY)"
	@echo "Kernel instalado: $(KERNEL_DISPLAY)"

.PHONY: init
init: install kernel ## Inicializa el proyecto (venv + deps + kernel)

.PHONY: activate-hint
activate-hint: ## Cómo activar el venv
	@echo "source .venv/bin/activate"

.PHONY: freeze
freeze: ## Congela dependencias en requirements.lock.txt
	$(PIP) freeze > requirements.lock.txt
	@echo "Escrito requirements.lock.txt"

.PHONY: which
which: ## Muestra el Python y pip del venv
	@$(PY) -c "import sys; print('PYTHON =', sys.executable)"
	@$(PY) -m pip --version

.PHONY: jlab
jlab: ## Inicia JupyterLab usando el venv
	@$(PY) -m jupyter lab

.PHONY: clean
clean: ## Limpia artefactos, checkpoints y el venv
	@find . -name "__pycache__" -type d -prune -exec rm -rf {} + 2>/dev/null || true
	@find . -name ".ipynb_checkpoints" -type d -prune -exec rm -rf {} + 2>/dev/null || true
	@rm -rf .pytest_cache build dist *.egg-info 2>/dev/null || true
	@rm -rf $(VENV) 2>/dev/null || true
	@echo "Limpieza completada"
