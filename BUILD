# Copyright 2021 Aaron Webster
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     https://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

load("@rules_pkg//:pkg.bzl", "pkg_deb", "pkg_tar")

pkg_tar(
    name = "mode600_files",
    srcs = glob(["skel/mode600/**"]),
    mode = "0600",
    strip_prefix = "skel/mode600",
    symlinks = {"/opt/winterman/autossh/id_rsa": "/home/winterman/.ssh/id_rsa"},
)

pkg_tar(
    name = "mode644_files",
    srcs = glob(["skel/mode644/**"]),
    mode = "0644",
    strip_prefix = "skel/mode644",
)

pkg_tar(
    name = "mode755_files",
    srcs = glob(["skel/mode755/**"]),
    mode = "0755",
    strip_prefix = "skel/mode755",
)

pkg_tar(
    name = "debian_data",
    extension = "tar.gz",
    deps = [
        ":mode600_files",
        ":mode644_files",
        ":mode755_files",
    ],
)

genrule(
    name = "version",
    outs = ["VERSION"],
    cmd = "./$(location tools/make_build_info.sh) > \"$@\"",
    stamp = 1,
    tools = ["tools/make_build_info.sh"],
)

pkg_deb(
    name = "winterman_deb",
    data = ":debian_data",
    depends = [
        "autossh",
        "locate",
	# No creds in package, manual configuration required.
        "ddclient", 
        "openvpn",
    ],
    description = "Winterman System Package",
    homepage = "https://github.com/AaronWebster/winterman",
    maintainer = "Aaron Webster",
    package = "winterman",
    postinst = "postinst",
    version_file = "VERSION",
)
