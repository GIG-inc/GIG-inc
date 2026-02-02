fn main() -> Result<(), Box<dyn std::error::Error>> {
    let protoc_path = protoc_bin_vendored::protoc_bin_path()?;

    // This is REQUIRED so prost-build can see protoc
    unsafe {
        std::env::set_var("PROTOC", protoc_path);
    }

    tonic_build::configure()
        .build_server(true)
        .build_client(false)
        .compile_protos(&["../proto/auth.proto"], &["../proto"])?;

    println!("cargo:rerun-if-changed=../proto");

    Ok(())
}
