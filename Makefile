ALL_PROTOBUF_FILES=./Protobuf/flow/**/*.proto
GENERATED_SOURCES_PATH=./Sources/FlowSDK/Protobuf/Generated
GENERATED_TESTS_PATH=./Tests/FlowSDKTests/Generated

install:
	brew list swift-protobuf || brew install swift-protobuf
	brew list grpc-swift || brew install grpc-swift

generate-protobuf: clean
	mkdir -p ${GENERATED_SOURCES_PATH}
	protoc ${ALL_PROTOBUF_FILES} \
		-I=./Protobuf \
		--swift_opt=Visibility=Public \
		--swift_out=${GENERATED_SOURCES_PATH}
	protoc ${ALL_PROTOBUF_FILES} \
		-I=./Protobuf \
		--grpc-swift_opt=Client=true,Server=false,Visibility=Public \
		--grpc-swift_out=${GENERATED_SOURCES_PATH}

	mkdir -p ${GENERATED_TESTS_PATH}
	protoc ${ALL_PROTOBUF_FILES} \
		-I=./Protobuf \
		--grpc-swift_opt=Client=false,Server=true,ExtraModuleImports=FlowSDK \
		--grpc-swift_out=${GENERATED_TESTS_PATH}

clean:
	if [ -d "${GENERATED_SOURCES_PATH}" ]; then rm -r ${GENERATED_SOURCES_PATH}; fi
	if [ -d "${GENERATED_TESTS_PATH}" ]; then rm -r ${GENERATED_TESTS_PATH}; fi
