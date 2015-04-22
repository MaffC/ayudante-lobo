class Ayudantelobo < Formula
  homepage "https://github.com/MaffC/ayudante-lobo"
  url "https://github.com/MaffC/ayudante-lobo/archive/v0.9.6.tar.gz"
  sha256 "e80ad2a4fbd1f8b3abdb5ac47d855fa1cec01b8e6ef127a7e833a2088019e066"
  head "https://github.com/MaffC/ayudante-lobo.git"

  depends_on "cpanminus"
  depends_on "libssh2"
#  depends_on "Mac::Pasteboard" => :perl
#  depends_on "Net::SSH2" => :perl
#  depends_on "POE" => :perl
#  depends_on "POE::Component::DirWatch::WithCaller" => :perl
#  depends_on "Try::Tiny" => :perl
#  depends_on "Unix::PID" => :perl
#  depends_on "YAML" => :perl

  def install
  bin.mkpath
  share.mkpath
  lib.mkpath
  mkdir_p lib/"Maff/Common"
  bin.install "ayudante-lobo"
  share.install "sample.ayudante-loborc"
  mv "lib/Maff-Common-OSX.pm",lib/"Maff/Common/OSX.pm"
  prefix.install_metafiles
  system "cpanm",
    "-q", "--exclude-vendor", "-l", "#{prefix}", "Mac::Pasteboard",
    "Net::SSH2", "POE::Component::DirWatch::WithCaller",
    "Try::Tiny", "Unix::PID", "YAML"
  end

  test do
    system "perl -c #{bin}/ayudante-lobo"
  end

  def caveats
    "You'll need to copy #{share}/sample.ayudante-loborc to ~/.ayudante-loborc and then edit it to your needs before loading the launchd agent. The agent is designed such that if ayudante-lobo encounters an error, it will be silently restarted and the error will be logged to wherever you've configured it to log errors to."
  end

  def plist; <<-EOS.undent
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple Computer//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
      <dict>
        <key>Label</key>
        <string>#{plist_name}</string>
        <key>KeepAlive</key>
        <true/>
        <key>RunAtLoad</key>
        <true/>
        <key>EnvironmentVariables</key>
        <dict>
          <key>PERL5LIB</key>
          <string>#{lib}:#{lib}/perl5:#{lib}/perl5/darwin-thread-multi-2level</string>
        </dict>
        <key>Program</key>
        <string>#{bin}/ayudante-lobo</string>
      </dict>
    </plist>
    EOS
  end
end
