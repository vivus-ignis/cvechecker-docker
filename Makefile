F_CVECHECKER_BUILD_IMAGE := .f_cvechecker_build_image
F_CVESCAN_BUILD_IMAGE    := .f_cvescan_build_image

cvescan/cvescan: $(F_CVESCAN_BUILD_IMAGE)
	docker run \
	  -v $(CURDIR)/cvescan:/tmp/cvescan \
	  -w /tmp/cvescan \
	  cvescan crystal build src/cvescan.cr --static

$(F_CVECHECKER_BUILD_IMAGE):
	docker build -t cvechecker .
	touch $@

$(F_CVESCAN_BUILD_IMAGE):
	cd cvescan; docker build -t cvescan .
	touch $@

output/cvechecker/cvechecker: $(F_CVECHECKER_BUILD_IMAGE)
	docker run --rm -v $(PWD)/output/cvechecker:/tmp/output cvechecker

clean:
	sudo rm -f cvescan/cvescan
	sudo rm -rf $(CVECHECKER_BUILD_OUTPUT)

# test-ubuntu: output/cvechecker/cvechecker cvescan/cvescan
test-ubuntu: cvescan/cvescan
	docker run --rm -ti \
	  -v $(CURDIR)/output/cvechecker:/opt/cvechecker \
	  -v $(CURDIR)/cvescan/cvescan:/usr/bin/cvescan \
	  -e CVESCAN_DEBUG=1 \
	  ehighway-cfn /usr/bin/cvescan
