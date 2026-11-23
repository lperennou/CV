# Makefile for CV compilation
# Compiles src/cv.tex to produce cv.pdf at the root
# Intermediate files go to build/

.PHONY: all clean cv

# Compiler
XELATEX = xelatex

# Source directory
SRC_DIR = src

# Build directory for intermediate files
BUILD_DIR = build

# Output directory (root for final PDF)
OUTPUT_DIR = .

# Main CV file
CV_TEX = $(SRC_DIR)/cv.tex
CV_PDF = $(OUTPUT_DIR)/cv.pdf

# All TeX source files
CV_SRCS = $(wildcard $(SRC_DIR)/*.tex $(SRC_DIR)/*.cls $(SRC_DIR)/*.sty $(SRC_DIR)/*.bib)

all: cv

# Main CV target
cv: $(CV_PDF)

# Compile CV: run xelatex twice to resolve references
$(CV_PDF): $(CV_SRCS) | $(BUILD_DIR)
	TEXINPUTS=$(SRC_DIR):$(TEXINPUTS) $(XELATEX) -output-directory=$(BUILD_DIR) -interaction=nonstopmode $(CV_TEX)
	TEXINPUTS=$(SRC_DIR):$(TEXINPUTS) $(XELATEX) -output-directory=$(BUILD_DIR) -interaction=nonstopmode $(CV_TEX)
	# Copy final PDF to root
	cp $(BUILD_DIR)/cv.pdf $(CV_PDF)

# Create build directory if it doesn't exist
$(BUILD_DIR):
	mkdir -p $(BUILD_DIR)

# Clean build artifacts
clean:
	rm -rf $(BUILD_DIR)/*.aux $(BUILD_DIR)/*.log $(BUILD_DIR)/*.out $(BUILD_DIR)/*.toc $(BUILD_DIR)/*.fls
	rm -rf $(BUILD_DIR)/cover_letters/

# Clean everything including final PDF
clean-all: clean
	rm -f $(CV_PDF)

# Compile all cover letters in src/cover_letters/
cover-letters:
	for file in $(SRC_DIR)/cover_letters/*.tex; do \
		base=$(notdir $$file); \
		$(XELATEX) -output-directory=$(BUILD_DIR)/cover_letters -interaction=nonstopmode $$file; \
		$(XELATEX) -output-directory=$(BUILD_DIR)/cover_letters -interaction=nonstopmode $$file; \
	done

# Show help
help:
	@echo "Available targets:"
	@echo "  all       - Build main CV (default)"
	@echo "  cv        - Build main CV"
	@echo "  clean     - Remove build artifacts"
	@echo "  clean-all - Remove build artifacts and final PDF"
	@echo "  cover-letters - Build all cover letters"
