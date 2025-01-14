# when ctest is ran, each submodule includes this file to generate the <submodule>_tests.cmake file.
# <submodule>_tests.cmake contains the add_test macro which runs the individual test.

get_filename_component(_cmake_path cmake ABSOLUTE)

if(NOT EXISTS "${ctestfilepath}")
  foreach(EXEC_NAME ${exc_names})
    if(WIN32)
      set(EXEC_NAME ${EXEC_NAME}.exe)
    endif()
    if(EXISTS "${EXEC_NAME}")
      execute_process(
      COMMAND "${_cmake_path}"
              -D "TEST_TARGET=${TARGET}"
              -D "TEST_EXECUTABLE=${EXEC_NAME}"
              -D "TEST_EXECUTOR=${crosscompiling_emulator}"
              -D "TEST_WORKING_DIR=${_workdir}"
              -D "TEST_SPEC=${_TEST_SPEC}"
              -D "TEST_EXTRA_ARGS=${_EXTRA_ARGS}"
              -D "TEST_PROPERTIES=${_PROPERTIES}"
              -D "TEST_PREFIX=${_TEST_PREFIX}"
              -D "TEST_SUFFIX=${_TEST_SUFFIX}"
              -D "TEST_LIST=${_TEST_LIST}"
              -D "TEST_REPORTER=${_REPORTER}"
              -D "TEST_OUTPUT_DIR=${_OUTPUT_DIR}"
              -D "TEST_OUTPUT_PREFIX=${_OUTPUT_PREFIX}"
              -D "TEST_OUTPUT_SUFFIX=${_OUTPUT_SUFFIX}"
              -D "CTEST_FILE=${ctestfilepath}"
              -P "${_CATCH_ADD_TEST_SCRIPT}"
      OUTPUT_VARIABLE output
      RESULT_VARIABLE result
      WORKING_DIRECTORY "${TEST_WORKING_DIR}"
      )
    else()
      message("executable not found : ${EXEC_NAME}" )
    endif()
  endforeach()
endif()

if(EXISTS "${ctestfilepath}")
  # include the generated ctest file for execution
  include(${ctestfilepath})
endif()
