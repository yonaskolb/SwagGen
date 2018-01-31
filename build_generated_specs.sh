for spec in Specs/**
do
    echo ""
    echo "📦  Building ${spec}"
    swift build --package-path ${spec}/generated/Swift --build-path Specs/.build -c release
    rm ${spec}/generated/Swift/Package.resolved
done
