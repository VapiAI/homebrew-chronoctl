class ChronoctlAT1350 < Formula
  desc "Manage Chronosphere Observability Platform resources"
  homepage "https://docs.chronosphere.io/tooling/chronoctl"
  url "https://github.com/chronosphereio/chronoctl-core/archive/refs/tags/v1.35.0.tar.gz"
  sha256 "87e59623847274b584ac8cbe6f7aded5560f01b2898d15ffcf950bfc53a98574"
  license "Apache-2.0"

  keg_only :versioned_formula
  depends_on "go" => :build

  def install
    build_package = "github.com/chronosphereio/chronoctl-core/src/cmd/pkg/buildinfo"
    ldflags = %W[
      -X #{build_package}.SHA=5f038f1
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
