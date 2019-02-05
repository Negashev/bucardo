FROM alpine
RUN apk add --update perl perl-dbd-pg
RUN apk add --update git build-base make
RUN git clone git://github.com/bucardo/bucardo.git
WORKDIR /bucardo
RUN perl Makefile.PL
RUN make install
RUN bucardo --version

RUN git clone git://github.com/bucardo/dbixsafe.git /dbixsafe
WORKDIR /dbixsafe
RUN perl Makefile.PL
RUN make install

FROM alpine
RUN apk add --update perl perl-dbd-pg
ENTRYPOINT ["/entrypoint.sh"]
CMD ["/bin/sh"]
COPY entrypoint.sh entrypoint.sh
RUN chmod +x entrypoint.sh
COPY --from=0 /bucardo/bucardo /usr/local/bin/bucardo
COPY --from=0 /usr/local/lib/perl5/site_perl/auto/DBIx /usr/local/lib/perl5/site_perl/auto/DBIx
COPY --from=0 /usr/local/share/perl5/site_perl/DBIx /usr/local/share/perl5/site_perl/DBIx
COPY --from=0 /usr/local/share/man/man3/DBIx::Safe.3pm /usr/local/share/man/man3/DBIx::Safe.3pm
