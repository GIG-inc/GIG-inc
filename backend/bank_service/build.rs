fn main() {
    tonic_build::configure()
        .build_server(true)
        .build_client(false)
        .compile_protos(&["../proto/bank.proto"], &["../proto"])
        .unwrap();
}
