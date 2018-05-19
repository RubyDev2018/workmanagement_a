"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const completions_1 = require("@heroku-cli/command/lib/completions");
const cli_ux_1 = require("cli-ux");
const debug = require('debug')('heroku:completions');
exports.completions = async function () {
    if (this.config.windows) {
        debug('skipping autocomplete on windows');
    }
    else {
        const acPlugin = this.config.plugins.find(p => p.name === '@heroku-cli/plugin-autocomplete');
        if (acPlugin) {
            cli_ux_1.default.action.start('Updating completions');
            let acCreate = await acPlugin.findCommand('autocomplete:create');
            if (acCreate) {
                const config = this.config;
                await acCreate.run([], config);
                await completions_1.AppCompletion.options({ config });
                await completions_1.PipelineCompletion.options({ config });
                await completions_1.SpaceCompletion.options({ config });
                await completions_1.TeamCompletion.options({ config });
            }
        }
        else {
            debug('skipping autocomplete, not installed');
        }
        cli_ux_1.default.done();
    }
};
