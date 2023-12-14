FROM panard/mtgo:wow64

RUN winetricks -q d3dcompiler_47 win10 msxml3 nocrashdialog && \
    rm -rf /home/wine/.cache
RUN winetricks grabfullscreen=y usetakefocus=n

RUN curl -fOL https://mtgarena.downloads.wizards.com/Live/Windows32/MTGAInstaller.exe
#RUN wine MTGAInstaller.exe /Q

CMD ["/usr/bin/wine", ".wine/drive_c/Program Files/Wizards of the Coast/MTGA/MTGA.exe"]

USER root
RUN pacman -Syy \
    && pacman -S --noconfirm \
        mesa-utils\
        pciutils\
        pulseaudio\
        vulkan-intel \
    && pacman -Scc

RUN pacman -Syy \
    && pacman -S --noconfirm \
        vulkan-tools \
    && pacman -Scc --noconfirm

COPY pulse-client.conf /etc/pulse/client.conf
COPY start-mtga /usr/local/bin/mtga

USER wine

RUN winetricks renderer=vulkan

