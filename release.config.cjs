const providerPlugin = [
    "@semantic-release/github",
    {
        successComment: false,
        failComment: false,
        releasedLabels: false
    }
];

module.exports = {
    branches: ["main"],
    tagFormat: "v${version}",
    plugins: [
        [
            "@semantic-release/commit-analyzer",
            {
                preset: "conventionalcommits"
            }
        ],
        [
            "@semantic-release/release-notes-generator",
            {
                preset: "conventionalcommits"
            }
        ],
        providerPlugin
    ]
};
