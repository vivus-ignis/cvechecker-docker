FROM ubuntu:bionic
RUN apt-get update \
  && apt-get install -y ruby ruby-dev bundler \
  libgmp-dev build-essential autoconf git pkg-config \
  libtool flex bison wget xsltproc
RUN gem install omnibus --no-ri --no-rdoc
COPY omnibus-cvechecker /tmp/omnibus-cvechecker
WORKDIR /tmp/omnibus-cvechecker
RUN omnibus build cvechecker && omnibus clean cvechecker
RUN dpkg -i ./pkg/*.deb
ENV PATH=/opt/cvechecker/embedded/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
RUN /opt/cvechecker/embedded/bin/cvechecker -i
RUN /opt/cvechecker/embedded/bin/pullcves pull; [ $? -eq 3 ] || exit 1 # normal operation has retcode 3
ENTRYPOINT /opt/cvechecker/embedded/bin/pullcves pull; cp -r /opt/cvechecker/ /tmp/output/

# Usage:
# ======
# - run this image with a mounted volume that points to /tmp/cvechecker-{hash} on the host
#   docker run -v /tmp/cvechecker-{hash}:/tmp/output cvechecker
# - run an app image to be scanned, mount /tmp/cvechecker-{hash}/cvechecker to it as /opt/cvechecker
#   docker run -ti -v $PWD/output/cvechecker:/opt/cvechecker app-image bash
# - generate a scanlist
#   docker$ cd /opt/cvechecker; find / -type f -perm -o+x > scanlist.txt; echo "/proc/version" >> scanlist.txt
# - run scan
#   docker$ ./embedded/bin/cvechecker -b scanlist.txt
# - generate CSV report
#   docker$ ./embedded/bin/cvechecker -rC
# - retcode != 0 if issues found
