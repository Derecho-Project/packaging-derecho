EAPI=7
SRC_URI="https://github.com/ofiwg/libfabric/archive/v${PV}.tar.gz"
inherit autotools 
DESCRIPTION="Open Fabric Interfaces"
HOMEPAGE="http://libfabric.org/"

KEYWORDS=amd64

LICENSE="BSD"
SLOT=0

RDEPEND="
>=sys-fabric/librdmacm-1.1.0
sys-fabric/libibverbs
sys-fabric/libibumad
"
DEPEND="${RDEPEND}"

src_prepare(){
  eautoreconf
	eapply_user
}
