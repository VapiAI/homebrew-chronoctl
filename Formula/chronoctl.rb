class Chronoctl < Formula
  desc "Manage Chronosphere Observability Platform resources"
  homepage "https://docs.chronosphere.io/tooling/chronoctl"
  url "https://github.com/chronosphereio/chronoctl-core/archive/refs/tags/v1.33.0.tar.gz"
  sha256 "e41ae46da2d6ddba9da7552a1ab169f9d9962be5487d91bef7ffdd24509775d0"
  license "Apache-2.0"
  head "https://github.com/chronosphereio/chronoctl-core.git", branch: "main"

  livecheck do
    url :head
    strategy :git
  end

  depends_on "go" => :build

  def install
    build_package = "github.com/chronosphereio/chronoctl-core/src/cmd/pkg/buildinfo"
    ldflags = %W[
      -X #{build_package}.SHA=620f8f0
      -X #{build_package}.Version=v#{version}
    ]

    system "go", "build", *std_go_args(ldflags:), "./src/cmd/chronoctl"
    generate_completions_from_executable(bin/"chronoctl", "completion")
  end

  test do
    assert_match "Version: v#{version}", shell_output("#{bin}/chronoctl version")
  end
end
