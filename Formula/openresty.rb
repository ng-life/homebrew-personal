require 'etc'

class Openresty < Formula
  desc "Scalable Web Platform by Extending NGINX with Lua"
  homepage "https://openresty.org"
  VERSION = "1.27.1.2".freeze
  revision 1

  stable do
    url "https://openresty.org/download/openresty-#{VERSION}.tar.gz"
    sha256 "74f076f7e364b2a99a6c5f9bb531c27610c78985abe956b442b192a2295f7548"

    #patch do
    #  url "https://raw.githubusercontent.com/openresty/openresty/refs/heads/master/patches/LuaJIT2-20241104.patch"
    #  sha256 "5e1f56e32f481cd42c73612af7b6e4a06ee5a6f1f711553a76fb505ca2dfebeb"
    #end
  end

  option "with-postgresql", "Compile with ngx_http_postgres_module"
  option "with-iconv", "Compile with ngx_http_iconv_module"
  option "with-slice", "Compile with ngx_http_slice_module"

  depends_on "libmaxminddb"
  depends_on "openresty/brew/openresty-openssl3"
  depends_on "pcre2"
  depends_on "postgresql" => :optional

  skip_clean "site"
  skip_clean "pod"
  skip_clean "nginx"
  skip_clean "luajit"

  def install
    # Configure
    cc_opt = "-I#{HOMEBREW_PREFIX}/include -I#{Formula["pcre2"].opt_include} -I#{Formula["openresty/brew/openresty-openssl3"].opt_include}"
    ld_opt = "-L#{HOMEBREW_PREFIX}/lib -L#{Formula["pcre2"].opt_lib} -L#{Formula["openresty/brew/openresty-openssl3"].opt_lib}"

    args = %W[
      -j#{Etc.nprocessors}
      --prefix=#{prefix}
      --pid-path=#{var}/run/openresty.pid
      --lock-path=#{var}/run/openresty.lock
      --conf-path=#{etc}/openresty/nginx.conf
      --http-log-path=#{var}/log/nginx/access.log
      --error-log-path=#{var}/log/nginx/error.log
      --with-cc-opt=#{cc_opt}
      --with-ld-opt=#{ld_opt}
      --with-pcre-jit
      --without-http_rds_json_module
      --without-http_rds_csv_module
      --without-lua_rds_parser
      --with-ipv6
      --with-stream
      --with-stream_ssl_module
      --with-stream_ssl_preread_module
      --with-http_v2_module
      --without-mail_pop3_module
      --without-mail_imap_module
      --without-mail_smtp_module
      --with-http_stub_status_module
      --with-http_realip_module
      --with-http_addition_module
      --with-http_auth_request_module
      --with-http_secure_link_module
      --with-http_random_index_module
      --with-http_geoip_module
      --with-http_gzip_static_module
      --with-http_sub_module
      --with-http_dav_module
      --with-http_flv_module
      --with-http_mp4_module
      --with-http_gunzip_module
      --with-threads
      --with-compat
      --with-luajit-xcflags=-DLUAJIT_NUMMODE=2\ -DLUAJIT_ENABLE_LUA52COMPAT\ -fno-stack-check
    ]

    args << "--with-http_postgres_module" if build.with? "postgresql"
    args << "--with-http_iconv_module" if build.with? "iconv"
    args << "--with-http_slice_module" if build.with? "slice"

    system "./configure", *args

    # Install
    system "make"
    system "make", "install"
  end

  service do
    run [opt_prefix/"bin/openresty", "-g", "daemon off;"]
    working_dir HOMEBREW_PREFIX
    keep_alive true
    require_root true
  end

  def caveats
    <<~EOS
      You can find the configuration files for openresty under #{etc}/openresty/.
    EOS
  end

  test do
    system "#{bin}/openresty", "-V"
  end
end
