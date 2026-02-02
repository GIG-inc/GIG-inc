fn main() -> Result<(), Box<dyn std::error::Error>> {
    let protoc_path = protoc_bin_vendored::protoc_bin_path()?;

    // Tell Cargo to set PROTOC for this build (safe, no unsafe block)
    println!("cargo:rustc-env=PROTOC={}", protoc_path.display());

    tonic_build::configure()
        .build_server(true)
        .build_client(false)
        .compile_protos(&["../proto/auth.proto"], &["../proto"])?;

    println!("cargo:rerun-if-changed=../proto");

    Ok(())
}
