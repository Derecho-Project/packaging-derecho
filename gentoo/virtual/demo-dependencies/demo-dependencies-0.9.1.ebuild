EAPI=7
DESCRIPTION="Derecho is an open-source C++ distributed computing toolkit that provides strong forms of distributed coordination and consistency at RDMA speeds.  This metapackage pulls in dependencies for the Derecho SOSP tutorial"
HOMEPAGE="https://derecho.cs.cornell.edu/"

LICENSE="BSD"
SLOT=0

KEYWORDS=amd64

RDEPEND="
dev-libs/derecho
media-libs/opencv
sci-libs/incubator-mxnet
net-libs/grpc
"
DEPEND="${RDEPEND}"
