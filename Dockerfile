FROM registry.access.redhat.com/ubi8/ubi-minimal

COPY scripts/ /usr/local/bin/

USER 1001

EXPOSE 8444

CMD ["/usr/local/bin/start.sh"]
