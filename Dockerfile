FROM ubuntu:23.04

RUN usermod -d /home/user ubuntu
VOLUME /home/user

ENV DEBIAN_FRONTEND=noninteractive

RUN apt update
RUN apt install -y \
        cabextract\
        mesa-utils\
        pciutils\
        pulseaudio\
        software-properties-common\
        xserver-xorg-video-all\
        wget && \
    apt clean -y
COPY pulse-client.conf /etc/pulse/client.conf

RUN mkdir -pm755 /etc/apt/keyrings && \
    wget -O /etc/apt/keyrings/winehq-archive.key https://dl.winehq.org/wine-builds/winehq.key && \
    wget -NP /etc/apt/sources.list.d/ https://dl.winehq.org/wine-builds/ubuntu/dists/lunar/winehq-lunar.sources
RUN dpkg --add-architecture i386 && \
    apt update && \
    apt install -y winehq-stable && \
    apt clean -y

ADD https://raw.githubusercontent.com/calheb/winetricks/e3d25a174d27ef5109803e597af2d65085755334/src/winetricks /usr/bin/winetricks
RUN chmod 755 /usr/bin/winetricks

ENV USER=ubuntu
USER ubuntu

ENV WINEDEBUG -all,err+all,warn+chain,warn+cryptnet

WORKDIR /home/user
RUN wineboot -i && \
    winetricks -q dotnet48 && \
    winetricks -q arial && \
    rm -rf /home/user/.cache
RUN winetricks -q d3dcompiler_47 win10 msxml3 nocrashdialog && \
    rm -rf /home/user/.cache
RUN winetricks grabfullscreen=y usetakefocus=n

RUN wget https://mtgarena.downloads.wizards.com/Live/Windows32/MTGAInstaller.exe
RUN wine MTGAInstaller.exe /Q

CMD ["/usr/bin/wine", ".wine/drive_c/Program Files/Wizards of the Coast/MTGA/MTGA.exe"]
