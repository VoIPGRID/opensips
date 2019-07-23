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

ARG VER=2.4.6

RUN mkdir -p /opensips-$VER/packaging/debian
ADD packaging/debian /opensips-$VER/packaging/debian

WORKDIR /opensips-$VER
RUN mk-build-deps --install --tool='apt-get -o Debug::pkgProblemResolver=yes --no-install-recommends --yes' packaging/debian/control

ADD . /opensips-$VER
ARG VGVER=1vg3~deb9
RUN rm opensips-build-deps_$VER-${VGVER}_amd64.deb

# Save a source tar-gz and make the deb packages
RUN tar -czf /opensips_$VER.orig.tar.gz -C / opensips-$VER
RUN make deb
