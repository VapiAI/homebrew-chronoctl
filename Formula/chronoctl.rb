class Chronoctl < Formula
  desc "Manage Chronosphere Observability Platform resources"
  homepage "https://docs.chronosphere.io/tooling/chronoctl"
  url "https://github.com/chronosphereio/chronoctl-core/archive/refs/tags/v1.36.0.tar.gz"
  sha256 "e79783ec78195f3af1396d18a7066ce95675deaa3a6dc40c44c4235e04bd8d1f"
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
      -X #{build_package}.SHA=fd026d3
      -X #{build_package}.Version=v#{version}
    ]

    system "go", "build", *std_go_args(ldflags:, output: bin/"chronoctl"), "./src/cmd/chronoctl"
    generate_completions_from_executable(bin/"chronoctl", "completion")
  end

  test do
    assert_match "Version: v#{version}", shell_output("#{bin}/chronoctl version")
    assert_match "kind: Monitor", shell_output("#{bin}/chronoctl monitors scaffold")
  end
end
