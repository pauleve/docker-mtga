FROM panard/mtgo:wow64-deb

RUN winetricks -q d3dcompiler_47 win10 msxml3 nocrashdialog && \
    rm -rf /home/wine/.cache
RUN winetricks grabfullscreen=y usetakefocus=n

RUN curl -fOL https://mtgarena.downloads.wizards.com/Live/Windows32/MTGAInstaller.exe
#RUN wine MTGAInstaller.exe /Q

CMD ["/opt/wine/bin/wine", ".wine/drive_c/Program Files/Wizards of the Coast/MTGA/MTGA.exe"]

USER root
RUN apt-get update\
    && apt-get install -y --no-install-recommends\
        mesa-utils\
        pciutils\
        pulseaudio\
        mesa-vulkan-drivers\
        vulkan-tools \
    && apt clean -y

COPY pulse-client.conf /etc/pulse/client.conf
COPY start-mtga /usr/local/bin/mtga

USER wine

RUN winetricks renderer=vulkan

