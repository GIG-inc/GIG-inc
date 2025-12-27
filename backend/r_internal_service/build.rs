fn main() {
    tonic_build::configure()
        .build_server(false)
        .build_client(true)
        .compile_protos(
            &[
                "../proto/auth.proto",
                "../proto/payments.proto",
            ],
            &["../proto"],
        )
        .unwrap();
}