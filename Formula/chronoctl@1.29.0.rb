class ChronoctlAT1290 < Formula
  desc "Manage Chronosphere Observability Platform resources"
  homepage "https://docs.chronosphere.io/tooling/chronoctl"
  url "https://github.com/chronosphereio/chronoctl-core/archive/refs/tags/v1.29.0.tar.gz"
  sha256 "750ba1724b7a8809d7ac1b3c7ac3084ed6e585dce4c99d734d6e9cf5b4df12bc"
  license "Apache-2.0"

  keg_only :versioned_formula

  depends_on "go" => :build

  def install
    build_package = "github.com/chronosphereio/chronoctl-core/src/cmd/pkg/buildinfo"
    ldflags = %W[
      -X #{build_package}.SHA=420fe8d
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
