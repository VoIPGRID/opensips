FROM debian:stretch

RUN apt-get update
RUN apt-get install --yes --no-install-recommends \
	git\
	build-essential\
	vim ca-certificates\
	fakeroot\
	ssl-cert\
	devscripts\
	equivs\
	init-system-helpers

ARG VER=2.4.4
ARG VGVER=1vg1~deb9

ADD . /opensips-$VER
WORKDIR /opensips-$VER

# Install build dependencies based on control file.
RUN mk-build-deps --install --tool='apt-get -o Debug::pkgProblemResolver=yes --no-install-recommends --yes' packaging/debian/control
RUN rm opensips-build-deps_$VER-${VGVER}_amd64.deb

# Save a source tar-gz and make the deb packages
RUN tar -czf /opensips_$VER.orig.tar.gz -C / opensips-$VER
RUN make deb 
