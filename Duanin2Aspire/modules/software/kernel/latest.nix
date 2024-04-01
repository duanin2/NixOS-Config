{ pkgs, ... }: {
	boot.kernelPackages = pkgs.linuxPackages-latest;
}
