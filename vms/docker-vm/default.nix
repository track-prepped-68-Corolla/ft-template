# =============================================================================
# docker-vm — standalone microVM guest: rootful Docker + Komodo (plaintext)
# =============================================================================
#
# Template shape for a docker + Komodo microVM. It is a STANDALONE guest — the
# framework's flake-parts/vms.nix discovers this directory and emits
# nixosConfigurations.docker-vm, which a host runs by reference:
#
#   # machines/<host>/default.nix
#   ft.microvms.instances.docker-vm = {
#     enable = true;
#     vmAddressSuffix = 2;              # last octet of the guest's IP
#     vmMac = "02:00:00:00:00:01";     # MUST match the tap MAC below
#     hostInterface = "eth0";          # host NIC for the VM's internet NAT
#   };
#
# Komodo's persistent/browsable state lives on the auto host share the guest
# baseline mounts at /srv/host-share (host /var/lib/microvm/docker-vm/share);
# Docker's own data is on a persistent volume image. Komodo runs on plaintext
# defaults — change the credentials before exposing it.
# =============================================================================
{ ... }:
{
  microvm.interfaces = [
    {
      type = "tap";
      id = "tap-docker-vm";
      mac = "02:00:00:00:00:01";
    }
  ];

  # Docker's data directory on a persistent disk image under the host state dir.
  microvm.volumes = [
    {
      image = "/var/lib/microvm/docker-vm/docker.img";
      mountPoint = "/var/lib/docker";
      size = 20480;
    }
  ];

  # Rootful Docker + the real docker-compose v2 binary; ft.komodo reaches the
  # daemon through ft.containers.socket.
  ft.containers = {
    enable = true;
    runtime = "docker";
    rootless = false;
    compose.enable = true;
  };

  # Komodo Core + Periphery + FerretDB on plaintext defaults. Its persistent data
  # dirs live on the auto host share so they survive guest rebuilds and are
  # browsable on the host under /var/lib/microvm/docker-vm/share.
  ft.komodo = {
    enable = true;
    backupsPath = "/srv/host-share/backups";
    peripheryRootDirectory = "/srv/host-share/periphery";
    repoCachePath = "/srv/host-share/repo-cache";
    syncPath = "/srv/host-share/syncs";
    includeDiskMounts = [
      "/"
      "/var/lib/docker"
      "/srv/host-share"
    ];
  };
}
