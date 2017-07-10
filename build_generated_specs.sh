for spec in Specs/**
do
    echo Building ${spec}
    swift build --chdir ${spec}/generated/Swift --build-path Specs/.build -c release
done
