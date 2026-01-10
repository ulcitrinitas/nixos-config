{
  config,
  lib,
  pkgs,
  ...
}: {
  # enable nix-flatpak declarative flatpaks
  services.flatpak = {
    enable = true;
    packages = [
      "com.discordapp.Discord"
      "io.github.thetumultuousunicornofdarkness.cpu-x"
      "me.proton.Mail"
      "org.nickvision.money"
      "org.gnome.Logs"
      "org.onlyoffice.desktopeditors"
      "md.obsidian.Obsidian"
      "ch.theologeek.Manuskript"
      "com.logseq.Logseq"
      "io.anytype.anytype"
    ];
    update.auto = {
      enable = true;
      onCalendar = "daily";
    };
  };

  systemd.services.flatpak-repo = {
    wantedBy = ["multi-user.target"];
    path = [pkgs.flatpak];
    script = ''
      flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
    '';
  };
}
