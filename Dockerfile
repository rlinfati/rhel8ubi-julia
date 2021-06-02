FROM registry.access.redhat.com/ubi8/ubi

ENV PATH=/opt/conda/bin:$PATH

USER root
WORKDIR /root

RUN useradd --create-home --no-user-group luser && \
    chgrp --recursive users /opt /usr/local && \
    chmod 0775 /opt /usr/local/bin /usr/local/lib

USER luser
WORKDIR /home/luser
EXPOSE 8888/tcp
VOLUME /home/luser/backup

# Jupyter Notebook and Hub
RUN curl --remote-name https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh && \
    bash Miniconda3-latest-Linux-x86_64.sh -b -p /opt/conda && \
    conda install --yes notebook jupyterhub tini && \
    rm Miniconda3-latest-Linux-x86_64.sh && \
    conda clean --all --yes

ENTRYPOINT ["tini", "-g", "--"]
CMD ["jupyter", "notebook", "--ip=0.0.0.0"]
EXPOSE 8888

# Julia config
ENV JULIA_DEPOT_PATH=/opt/julia-pkg
ENV JULIA_VERSION=1.6
ENV CPLEX_STUDIO_BINARIES=/usr/local/lib
ENV GUROBI_HOME=/usr/local

# Julia Install
RUN mkdir /opt/julia-${JULIA_VERSION} && \
    curl --remote-name https://julialang-s3.julialang.org/bin/linux/x64/${JULIA_VERSION}/julia-${JULIA_VERSION}-latest-linux-x86_64.tar.gz && \
    tar xzf julia-${JULIA_VERSION}-latest-linux-x86_64.tar.gz -C /opt/julia-${JULIA_VERSION} --strip-components=1 && \
    rm julia-${JULIA_VERSION}-latest-linux-x86_64.tar.gz && \
    ln --symbolic /opt/julia-${JULIA_VERSION}/bin/julia /usr/local/bin/julia && \
    julia -e "using Pkg; Pkg.add(\"IJulia\");"

# AMPL demo Install
RUN mkdir /opt/ampl.linux64 && \
    curl --remote-name https://ampl.com/demo/ampl.linux64.tgz && \
    tar xzf ampl.linux64.tgz -C /opt/ampl.linux64 --strip-components=1 && \
    rm ampl.linux64.tgz && \
    ln --symbolic /opt/ampl.linux64/libcplex*.so   /usr/local/lib && \
    ln --symbolic /opt/ampl.linux64/libgurobi*.so  /usr/local/lib && \
    mkdir /opt/gurobi && \
    echo TOKENSERVER=token.menoscero.com > /opt/gurobi/gurobi.lic

# Julia JuMP
RUN julia -e "using Pkg; Pkg.add(\"Plots\"); Pkg.add(\"JuMP\"); Pkg.add(\"GLPK\"); Pkg.add(\"CPLEX\"); Pkg.add(\"Gurobi\");"
