from passwddlg import getAccountInfo
from cmm import *
from profile import gPMConfig

import os.path

import svn.constants
import svn.common
import xml.etree.ElementTree

class SvnNewClient(svn.common.CommonClient):
    def __init__(self, url, *args, **kwargs):
        super(SvnNewClient, self).__init__(url,svn.constants.LT_URL,*args, **kwargs);
        self.__url_or_path = url;

    def checkout(self, path, revision=None):
        cmd = []
        if revision is not None:
            cmd += ['-r', str(revision)]

        cmd += [self.url, path]

        self.run_command('checkout', cmd)

    def diff_summary(self, old, new, rel_path=None):
        try:
            """Provides a summarized output of a diff between two revisions
            (file, change type, file type)
            """

            full_url_or_path = self.__url_or_path
            if rel_path is not None:
                full_url_or_path += '/' + rel_path

            arguments = [
                '-c{0}-{1}'.format(old,new),
                '{0}'.format(full_url_or_path),
                '--summarize',
                '--xml',
            ]

            result = self.run_command(
                'diff',
                arguments,
                do_combine=True)

            root = xml.etree.ElementTree.fromstring(result)

            diff = []
            for element in root.findall('paths/path'):
                diff.append({
                    'path': element.text,
                    'item': element.attrib['item'],
                    'kind': element.attrib['kind'],
                })

            return diff;
        except Exception as err:
            print(err);
            return None;
    #
    # def __repr__(self):
    #     return '<SVN(REMOTE) %s>' % self.url


class SvnUtils(object):
    def __init__(self,url):
        info = gPMConfig.getAccInfo();
        self.username = info[0];
        self.passwd = info[1];
        self.url = url;

    def safeRemoteSvnClient(self,svnlink):
        return SvnNewClient(svnlink,username=self.username,password=self.passwd);

    def handleSvnAuthFailedError(self,err):
        if (str(err)).find("Authentication failed") >= 0:
            try:
                getAcctInfo ();
                info = gPMConfig.getAccInfo();
                self.username   = info [0];
                self.passwd     = info [1];
                return True;
            except Exception as err:
                return False;
        else:
            return False;

    def dummy_call(self,**kwargs):
        pass

    def list(self):

        r = None;
        ret = None;
        try:
            r = self.safeRemoteSvnClient (self.url);
            ret = r.list ();
            arr = [];
            for name in ret:
                arr.append(name);
                pass
            return arr;
        except Exception as err:
            if self.handleSvnAuthFailedError (err) == True:
                """
                again 
                """
                return self.list();
        pass

    def properties(self):
        r = None;
        try:
            r = self.safeRemoteSvnClient (self.url);
            ret =  r.properties ();
            return ret;
        except Exception as err:
            if self.handleSvnAuthFailedError (err) == True:
                """
                again 
                """
                return self.properties();
        pass

    def status(self,**kwargs):
        r = None;
        try:
            r = self.safeRemoteSvnClient (self.url);
            return r.status (**kwargs);
        except Exception as err:
            if self.handleSvnAuthFailedError (err) == True:
                """
                again 
                """
                return self.status(**kwargs);
        pass

    def log_default(self,**kwargs):
        r = None;
        try:
            r = self.safeRemoteSvnClient (self.url);
            return r.log_default (**kwargs);
        except Exception as err:
            if self.handleSvnAuthFailedError (err) == True:
                """
                again 
                """
                return self.log_default(**kwargs);
        pass

    def diff_summary(self,old, new, rel_path=None):
        r = None;
        try:
            r = self.safeRemoteSvnClient (self.url);
            return r.diff_summary (old, new, rel_path);
        except Exception as err:
            if self.handleSvnAuthFailedError (err) == True:
                """
                again 
                """
                return self.diff_summary(old, new, rel_path);
        pass

    def export(self,to_path, revision=None, force=False):
        r = None;
        try:
            rc = self.safeRemoteSvnClient (self.url);

            cmd = [];
            if revision is not None:
                cmd += ['-r', str(revision)]
            cmd += [self.url, to_path]
            cmd.append('--force');
            cmd.append('--non-recursive');
            rc.run_command('export', cmd)

        except Exception as err:
            if self.handleSvnAuthFailedError (err) == True:
                """
                again 
                """
                return self.export(to_path, revision, force);
        pass

    '''SVN服务器Checkout'''
    def checkout(self, dst_path, force=False):
        r = None;
        try:
            rc = self.safeRemoteSvnClient(self.url);

            cmd = [];
            cmd += [self.url, dst_path]
            rc.run_command('export', cmd)

        except Exception as err:
            print(err);
            if self.handleSvnAuthFailedError(err) == True:
                """
                again
                """
                return self.checkout(dst_path, force);
        pass