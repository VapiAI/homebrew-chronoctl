class ChronoctlAT1320 < Formula
  desc "Manage Chronosphere Observability Platform resources"
  homepage "https://docs.chronosphere.io/tooling/chronoctl"
  url "https://github.com/chronosphereio/chronoctl-core/archive/refs/tags/v1.32.0.tar.gz"
  sha256 "6f6dad52133f7e9ea85ac53dcd9d9eee53862d4933f241f8900085de36613d03"
  license "Apache-2.0"

  keg_only :versioned_formula

  depends_on "go" => :build

  def install
    build_package = "github.com/chronosphereio/chronoctl-core/src/cmd/pkg/buildinfo"
    ldflags = %W[
      -X #{build_package}.SHA=249a2f6
      -X #{build_package}.Version=v#{version}
    ]

    system "go", "build", *std_go_args(ldflags:), "./src/cmd/chronoctl"
    generate_completions_from_executable(bin/"chronoctl", "completion")
  end

  test do
    assert_match "Version: v#{version}", shell_output("#{bin}/chronoctl version")
    assert_match "kind: Monitor", shell_output("#{bin}/chronoctl monitors scaffold")
  end
end
