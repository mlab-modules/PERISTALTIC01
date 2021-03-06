AMF_DIR := ../amf
STL_DIR := ../stl/4printing
ASSEMBLY_STL_DIR := ../stl/assembly
IMG_DIR := ../../doc/src/img/4printing
SRC_DIR := ./src/4printing
ASSEMBLY_DIR := ./src/assembly
DEP_DIR := ./dep
GCODE_DIR := ../amf/gcode
PLATE_DIMMENSIONS=120
SIMARRANGE=/usr/local/bin/simarrange
STLSORT := stlsort
AMFSORT := ./amfsort.py
OPENSCAD_APP := $(shell which openscad || which openscad-nightly)
MERGE_MODIFIERS := ./merge_modifiers.sh
MERGE_SLIC3R_CONF := ./merge_slic3r_conf.sh
SLICER_APP := Slic3r
VPATH := $(SRC_DIR):$(DEP_DIR):$(AMF_DIR):$(IMG_DIR)
SRC_FILES := $(filter-out src/bar.cpp, $(SRC_FILES))

SOURCES := $(wildcard $(SRC_DIR)/*.scad)
ASSEMBLIES := $(wildcard $(ASSEMBLY_DIR)/*.scad)
AMF := $(wildcard $(AMF_DIR)/*.amf)
STL := $(patsubst $(SRC_DIR)/%.scad, $(STL_DIR)/%.stl, $(SOURCES))
ASSEMBLY := $(patsubst $(ASSEMBLY_DIR)/%.scad, $(ASSEMBLY_STL_DIR)/%.stl, $(ASSEMBLIES))
TARGETS := $(patsubst $(SRC_DIR)/%.scad, $(AMF_DIR)/%.amf, $(SOURCES))
IMAGES := $(patsubst $(SRC_DIR)/%.scad, $(IMG_DIR)/%.png, $(SOURCES))
GCODE := $(patsubst $(AMF_DIR)/%.amf, $(GCODE_DIR)/%.gcode, $(AMF))

all : amf images stl gcode assembly

print : amf gcode

view : stl images

calibration:
	openscad -m make -o calibration.stl calibration.scad

amf : $(TARGETS)

$(AMF_DIR)/%.amf : $(SRC_DIR)/%.scad
	####################################################################################
	# MAKING AMF FOR $<
	####################################################################################
	#
	# Update dependencies and make no-draft version of model in AMF.
	$(OPENSCAD_APP) -D "draft = false" -m make -o $@ -d $(patsubst $(AMF_DIR)/%.amf, $(DEP_DIR)/%.deps, $@) $<
	# Remove absolute paths in dependencies.
	sed -i "s|$(shell pwd)/||" $(patsubst $(AMF_DIR)/%.amf, $(DEP_DIR)/%.deps, $@)
	# Sort deps file to keep git changes to minimum.
	sort -rf $(patsubst $(AMF_DIR)/%.amf, $(DEP_DIR)/%.deps, $@) -o $(patsubst $(AMF_DIR)/%.amf, $(DEP_DIR)/%.deps, $@)
	sed -i 's|[^\]$$|& \\|' $(patsubst $(AMF_DIR)/%.amf, $(DEP_DIR)/%.deps, $@)
	# Sort AMF file to keep git changes to minimum.
	$(AMFSORT) $@
	# Add modifiers to AMF files.
	$(MERGE_MODIFIERS) -v -a $@ -s $<

include $(wildcard $(DEP_DIR)/*.deps)

stl : $(STL)

$(STL_DIR)/%.stl : $(AMF_DIR)/%.amf
	####################################################################################
	# MAKING STL FOR $<
	####################################################################################
	#
	# Make no-draft version of model in STL.
	$(OPENSCAD_APP) -D "draft = false" -m make -o $@ $(patsubst $(STL_DIR)/%.stl, $(SRC_DIR)/%.scad, $@)
	# Sort stl file to keep git changes to minimum.
	$(STLSORT) $@ || :

images : $(IMAGES)

$(IMG_DIR)/%.png : $(STL_DIR)/%.stl
	####################################################################################
	# MAKING PNG FOR $<
	####################################################################################
	#
	# Create temporary file for fast image rendering.
	echo "import(\"$<\");" > tmp.scad
	# Render PNG image from temporary file.
	$(OPENSCAD_APP) -o $@ tmp.scad
	# Remove temporary file
	rm -f tmp.scad

assembly : $(ASSEMBLY)

$(ASSEMBLY_STL_DIR)/%.stl : $(ASSEMBLY_DIR)/%.scad
	####################################################################################
	# MAKING STL FOR $<
	####################################################################################
	# $(ASSEMBLY_STL_DIR)
	# Update dependencies and make no-draft version of model in STL.
	$(OPENSCAD_APP) -D 'stl_dir = "../../../stl/"' -D "draft = false" -m make -o $@ -d $(patsubst $(ASSEMBLY_STL_DIR)/%.stl, $(DEP_DIR)/%.deps, $@) $<
	# Remove absolute paths in dependencies.
	sed -i "s|$(shell pwd)/||" $(patsubst $(ASSEMBLY_STL_DIR)/%.stl, $(DEP_DIR)/%.deps, $@)
	# Sort deps file to keep git changes to minimum.
	sort -rf $(patsubst $(ASSEMBLY_STL_DIR)/%.stl, $(DEP_DIR)/%.deps, $@) -o $(patsubst $(ASSEMBLY_STL_DIR)/%.stl, $(DEP_DIR)/%.deps, $@)
	sed -i 's|[^\]$$|& \\|' $(patsubst $(ASSEMBLY_STL_DIR)/%.stl, $(DEP_DIR)/%.deps, $@)

gcode : $(GCODE)

$(GCODE_DIR)/%.gcode : $(AMF_DIR)/%.amf
	####################################################################################
	# MAKING GCODE FOR $<
	####################################################################################
	#
	# Generate gcode files.
	#$(SLICER_APP) --load default.ini -o $@ --no-gui -j 3 $<
	$(MERGE_SLIC3R_CONF) -v -s $(patsubst $(GCODE_DIR)/%.gcode, $(SRC_DIR)/%.scad, $@) -a $<
	mv $(patsubst $(AMF_DIR)/%.amf, $(AMF_DIR)/%.gcode, $<) $@

arrange : amf
	$(SIMARRANGE) -x $(PLATE_DIMMENSIONS) -y $(PLATE_DIMMENSIONS) $(ARRANGE_TARGETS)

clean:
	rm -f calibration.stl
	rm -f $(AMF_DIR)/*.amf
	rm -f $(AMF_DIR)/*.stl
	rm -f $(IMG_DIR)/*.png
