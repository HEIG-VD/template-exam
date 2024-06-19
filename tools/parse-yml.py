#!/usr/bin/python3
import sys
import yaml
import jinja2
import git
from textwrap import dedent
from babel.dates import format_date

if len(sys.argv) < 2:
    print(dedent('''
        Usage: parse-yml.py <file> < template

        Load metadata from a YAML file and render it using a Jinja2 template.
        Inject the Git SHA and URL of the repository.
        '''))
    exit(1)

with open(sys.argv[1], 'r') as f:
    yml = yaml.safe_load(f)

# Format date
yml['exam']['date'] = {
    'iso': yml['exam']['date'],
    'full': format_date(yml['exam']['date'], 'full', locale='fr_CH')
}

repo = git.Repo(search_parent_directories=True)
sha = repo.head.object.hexsha

yml['git'] = {
    'sha': sha,
    'url': 'https://github.com/' + repo.remotes.origin.url.split(':')[1].replace('.git','') + '/tree/' + sha
}

print(
    jinja2.Template(
        sys.stdin.read(),
        block_start_string = '\BLOCK{',
        block_end_string = '}',
        variable_start_string = '\VAR{',
        variable_end_string = '}',
        comment_start_string = '\#{',
        comment_end_string = '}',
        line_statement_prefix = '%%',
        line_comment_prefix = '%#',
        trim_blocks = False,
        autoescape = False
    ).render(data=yml)
)