const isGitLab = process.env.GITLAB_CI === "true";

const providerPlugin = isGitLab
    ? [
          "@semantic-release/gitlab",
          {
              successComment: false,
              failComment: false,
              labels: false
          }
      ]
    : [
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
