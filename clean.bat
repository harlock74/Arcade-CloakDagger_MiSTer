@echo off
setlocal
pushd "%~dp0" || exit /b 1
rem Remove generated Quartus output only; retain source, IP and releases.
for %%D in (db incremental_db output_files greybox_tmp hc_output .qsys_edit hps_isw_handoff) do (
    if exist "%%D\" rmdir /s /q "%%D"
)
if exist "*.qws" del /q "*.qws"
popd
endlocal
