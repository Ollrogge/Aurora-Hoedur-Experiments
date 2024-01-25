## Example firmware
This directory contains an example RIOT OS firmware with an artificial bug in the uri_parser component. If the passed uri has a special form, the firmware will crash:

```c
char* null_ptr_deref_easy(char* uri) {
    if (uri[4] == 0x41 && uri[5] == 0x42) {
        return NULL;
    }

    return uri;
}

int uri_parser_process(uri_parser_result_t *result, const char *uri,
                       size_t uri_len)
{
    /* uri cannot be empty */
    if ((NULL == uri) || (uri[0] == '\0')) {
        return -1;
    }

    uri = null_ptr_deref_easy((char*)uri);

    ...
}
```

### Fuzzing
**Create Hoedur config from firmware**
```bash
./scripts/run_in_docker.sh $PWD/example /home/user/hoedur/scripts/gen_config.py /home/user/hoedur-targets/arm/example
```
**Fuzz firmware**

Fuzz the firmware once for 2 minutes This will create `example/corpus`.
```bash
scripts/run_in_docker.sh $PWD/example /home/user/hoedur/scripts/fuzz-local.py --runs 1 --duration 2m --targets example
```

### Root cause analysis
**Obtain crash input ids**

Get basic information when a crash occured and the id of the input that caused it.
```bash
scripts/run_in_docker.sh $PWD/example /home/user/hoedur/scripts/eval-crash-time.py /home/user/hoedur-targets/arm/example/corpus --target example
```
**Run exploration mode for a specific crash id**

Run exploration mode on the input with id `7033` for 1 minute. You **probably have to** adjust the corpus path.
This will create `example/corpus/exploration`.
```bash
scripts/run_in_docker.sh $PWD/example /home/user/hoedur/scripts/exploration.py /home/user/hoedur-targets/arm/example/corpus/TARGET-example-FUZZER-hoedur-RUN-01-DURATION-2m-MODE-fuzzware.corpus.tar.zst -crash_id 7032  -duration 1
```
**Run root cause trace based on exploration results**

Again for example crashing input with id `7033`.
```bash
scripts/run_in_docker.sh $PWD/example /home/user/hoedur/scripts/root-cause-trace.py -crash_id 7033 /home/user/hoedur-targets/arm/example/corpus/
```
**Run Aurora**

The root cause analysis results will be stored in the target directory.
```bash
scripts/run_in_docker.sh $PWD/example rca --eval-dir /home/user/hoedur-targets/arm/example --trace-dir /home/user/hoedur-targets/arm/example/corpus/traces --monitor --rank-predicates --compound-predicates
```

